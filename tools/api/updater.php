<?php
/**
 * OTClient updater endpoint - thin version.
 * Reads a PRE-GENERATED manifest (no per-request hashing = no lag).
 * Regenerate with: /usr/local/bin/ascension-manifest
 * Deployed at: /var/www/ascension-web/updater.php on the VPS.
 */
$manifest_file = "/var/www/updates/manifest.json";

$binaries = array(
    "WIN32-WGL" => "Ascension.exe",
    "WIN32-EGL" => "Ascension.exe",
    "WIN32-WGL-GCC" => "Ascension.exe",
    "WIN32-EGL-GCC" => "Ascension.exe",
    "X11-GLX" => "otclient_linux",
    "X11-EGL" => "otclient_linux",
    "ANDROID-EGL" => "",   // android updates via store/apk
    "ANDROID64-EGL" => ""
);

$data = json_decode(file_get_contents("php://input"));
$platform = ($data && !empty($data->platform)) ? $data->platform : "";
$binary = isset($binaries[$platform]) ? $binaries[$platform] : "";

$ret = json_decode(file_get_contents($manifest_file), true);
if (!$ret) {
    echo json_encode(array("error" => "Updater manifest not generated yet"));
    die();
}

// binaries are handled separately (updated via updateExecutable, never written in-place)
$binaryChecksum = ($binary !== "" && isset($ret["files"]["/" . $binary])) ? $ret["files"]["/" . $binary] : null;
foreach (array("Ascension.exe", "otclient_dx_x64.exe", "otclient_linux") as $b) {
    unset($ret["files"]["/" . $b]);
}
if ($binaryChecksum !== null) {
    $ret["binary"] = array("file" => "/" . $binary, "checksum" => $binaryChecksum);
}

$body = json_encode($ret);
header("Content-Type: application/json");
header("Content-length: " . strlen($body));
echo $body;
