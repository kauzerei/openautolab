# Web Flashing Utility

Use this page to upgrade the Firmware on the OpenAutoLab Main Board to the [latest release](https://github.com/kauzerei/openautolab/releases) or [dev build](https://github.com/kauzerei/openautolab/actions/workflows/compile.yml) from the OpenAutoLab GitHub Repo.

<noscript>
    <p>Sorry. This functionality requires JavaScript. Please disable any blocking features.</p>
</noscript>
<div id="uploadWrap">
    <div>Download from GitHub:</div>
    <div id="wrapForm">
        <form id="fetchForm">
            <label>Release Channel:
                <select id="releaseChannel">
                    <option value="release">Releases</option>
                    <option value="build">Builds</option>
                </select>
            </label>
            <br>
            <button type="submit" id="fetchBtn">Fetch Versions</button>
        </form>
        <br>
        <form id="downloadForm">
            <label>Firmware Version:
                <select id="releaseVersion">
                </select>
            </label>
            <br>
            <button type="submit" id="downloadBtn">Download Firmware</button>
        </form>
    </div>
    <br>
    <div>Upload to Hardware:</div>
    <form id="uploadForm">
        <label>.zip or .hex file:
            <input id="fileInput" type="file" accept=".zip,.hex"/>
        </label>
        <br>
        <button type="submit" id="uploadBtn">Upload Firmware</button>
    </form>
    <br>
    <div>Status Log:</div>
    <div id="logWrap">
        <pre id="log"></pre>
    </div>
</div>
<script src="js/avrgirl-arduino.global.js" charset="UTF-8"></script>
<script src="js/zip.js" charset="UTF-8"></script>
<script src="js/flash.js" charset="UTF-8"></script>

## How-To

1. In the `Download` box, keep the pre-selected `Releases` channel.

1. Press the `Fetch Versions` button.

1. If in doubt, use the pre-selected latest `Version` that appeared.

1. Press the `Download Firmware` button.
This will start a download in your browser.

1. In the `Upload` box, press the `Choose File` button.

1. Select the file you just downloaded in the previous steps.

1. Press the `Upload Firmware` button.
This will start the flashing process.

1. Wait until you either see a success message or an error indication in the status log.

## Troubleshooting

Make sure you use a [WebSerial compatible browser](https://developer.mozilla.org/en-US/docs/Web/API/Web_Serial_API#browser_compatibility) like Chromium, Chrome or Edge.

Connect the Arduino Nano on the OpenAutoLab mainboard to your PC using a USB cable.

This should work on Linux, Mac OS X and Windows >= 10.
