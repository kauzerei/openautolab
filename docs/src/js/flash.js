const repo = "kauzerei/openautolab";

const fetchForm = document.getElementById('fetchForm');
const downloadForm = document.getElementById('downloadForm');
const uploadForm = document.getElementById('uploadForm');
const fetchBtn = document.getElementById('fetchBtn');
const downloadBtn = document.getElementById('downloadBtn');
const releaseChannel = document.getElementById('releaseChannel');
const releaseVersion = document.getElementById('releaseVersion');
const fileInput = document.getElementById('fileInput');
const logWrap = document.getElementById('logWrap');
const log = document.getElementById('log');

let currentChannel = "none";
let currentReleases = "";
let currentBuilds = "";

function appendToLog(s) {
    t = new Date().toLocaleTimeString();
    log.textContent += t + ": " + s + "\r\n";
    logWrap.scrollTop = logWrap.scrollHeight;
}

function clearVersions() {
    while (releaseVersion.length > 0) {
        releaseVersion.remove(0);
    }
    var option = document.createElement("option");
    option.text = "--- none ---";
    option.value = "none";
    releaseVersion.appendChild(option);
    downloadBtn.disabled = true;
}

function populateVersions(d) {
    while (releaseVersion.length > 0) {
        releaseVersion.remove(0);
    }
    for (i = 0; i < d.length; i += 2) {
        var option = document.createElement("option");
        option.text = d[i];
        option.value = d[i + 1];
        releaseVersion.appendChild(option);
    };
    if (d.length >= 2) {
        downloadBtn.disabled = false;
    }
}

function fetchReleases() {
    if (currentReleases != "") {
        populateVersions(currentReleases);
        return;
    }

    appendToLog("Fetching GitHub Releases...");
    (async () => {
        let releases = [];
        const response = await fetch('https://api.github.com/repos/' + repo + '/releases', {
            headers: {
                "X-GitHub-Api-Version": "2022-11-28",
            }
        });
        const json = await response.json();
        json.forEach((release, releaseIndex) => {
            release["assets"].forEach((asset, assetIndex) => {
                if (asset["name"] == "openautolab-hex.zip") {
                    releases.push(release["tag_name"]);
                    releases.push(asset["id"]);
                }
            });
        });
        return releases;
    })().then(releases => {
        currentReleases = releases;
        populateVersions(currentReleases);
        appendToLog("Done! Found " + currentReleases.length / 2 + " GitHub Release(s).");
    });
}

function fetchBuilds() {
    if (currentBuilds != "") {
        populateVersions(currentBuilds);
        return;
    }

    appendToLog("Fetching GitHub Dev Builds...");
    (async () => {
        let builds = [];
        const response = await fetch('https://api.github.com/repos/' + repo + '/actions/artifacts', {
            headers: {
                "X-GitHub-Api-Version": "2022-11-28",
            }
        });
        const json = await response.json();
        json["artifacts"].forEach((build, buildIndex) => {
            if (build["name"] == "openautolab.hex") {
                name = build["workflow_run"]["head_branch"] + ' @ ' + build["updated_at"]
                builds.push(name);

                url = build["workflow_run"]["id"] + "/artifacts/" + build["id"];
                builds.push(url);
            }
        });
        return builds;
    })().then(builds => {
        currentBuilds = builds;
        populateVersions(currentBuilds);
        appendToLog("Done! Found " + currentBuilds.length / 2 + " GitHub Dev Build(s).");
    });
}

function switchChannel(ch) {
    if (currentChannel != ch) {
        //appendToLog("Switching to '" + ch + "'");
        clearVersions();
        fetchBtn.disabled = false;
        if (ch == "release") {
            if (currentReleases != "") {
                populateVersions(currentReleases);
                fetchBtn.disabled = true;
            }
        } else if (ch == "build") {
            if (currentBuilds != "") {
                populateVersions(currentBuilds);
                fetchBtn.disabled = true;
            }
        }
    }
    currentChannel = ch;
}

function fetchChannel(ch) {
    //appendToLog("Fetching '" + ch + "'");
    fetchBtn.disabled = true;
    if (ch == "release") {
        fetchReleases();
    } else if (ch == "build") {
        fetchBuilds();
    }
}

function flash(filecontents) {
    navigator.serial.requestPort().then((port) => {
        let avrgirl = new AvrgirlArduino({
            board: 'nano',
            debug: appendToLog,
            port: port
        });

        avrgirl.flash(filecontents, (error) =>  {
            if (error) {
                appendToLog(error);
            } else {
                appendToLog('done!');
            }
        });
    }).catch((e) => {
        appendToLog('No valid serial port selected!');
    });
}

function submitFetch(e) {
    e.preventDefault();
    fetchChannel(releaseChannel.value);
}

function submitDownload(e) {
    e.preventDefault();

    if (currentChannel == "release") {
        n = -1;
        for (i = 0; i < currentReleases.length; i += 2) {
            if (currentReleases[i] == releaseVersion[releaseVersion.selectedIndex].text) {
                n = i;
            }
        }
        if (n < 0) {
            appendToLog("Could not find " + releaseVersion[releaseVersion.selectedIndex].text);
            return;
        }

        //const url = 'https://api.github.com/repos/' + repo + '/releases/assets/' + currentReleases[n + 1];
        const url = 'https://github.com/' + repo + '/releases/download/' + currentReleases[n] + '/openautolab-hex.zip';
        appendToLog("Starting download for '" + currentReleases[n] + "'");

        var iframe = document.createElement("iframe");
        iframe.style.display = 'none';
        iframe.src = url;
        document.body.appendChild(iframe);
    } else if (currentChannel == "build") {
        n = -1;
        for (i = 0; i < currentBuilds.length; i += 2) {
            if (currentBuilds[i] == releaseVersion[releaseVersion.selectedIndex].text) {
                n = i;
            }
        }
        if (n < 0) {
            appendToLog("Could not find " + releaseVersion[releaseVersion.selectedIndex].text);
            return;
        }

        const url = 'https://github.com/' + repo + '/actions/runs/' + currentBuilds[n + 1];
        appendToLog("Starting download for '" + currentBuilds[n] + "'");

        window.open(url);
    }
}

function submitUpload(e) {
    e.preventDefault();

    const file = fileInput.files[0];
    if (file) {
        if (file.name.endsWith(".zip")) {
            appendToLog(".zip file detected");
            (async () => {
                const zipFileReader = new zip.BlobReader(file);
                const zipReader = new zip.ZipReader(zipFileReader);

                const entries = await zipReader.getEntries();
                found = -1;
                for (i = 0; i < entries.length; i++) {
                    const entry = entries[i];
                    appendToLog("file: " + entry.filename);
                    if (entry.filename.endsWith("openautolab.ino.hex")) {
                        found = i;
                        break;
                    }
                }

                ret = ""
                if (found < 0) {
                    appendToLog("no matching hex file found in zip");
                } else {
                    const writer = new zip.Uint8ArrayWriter()
                    ret = await entries[found].getData(writer)
                }

                await zipReader.close();
                return ret;
            })().then(hex => {
                if (hex) {
                    appendToLog("Flashing hex from zip");
                    flash(hex);
                }
            });
        } else if (file.name.endsWith(".hex")) {
            appendToLog(".hex file detected");
            const reader = new FileReader();
            reader.onload = function(event) {
                flash(event.target.result);
            };
            reader.readAsArrayBuffer(file);
        } else {
            appendToLog("unsupported file type. need '.zip' or '.hex'!");
        }
    } else {
        appendToLog("No file selected!");
    }
}

function prepareListeners() {
    fetchForm.addEventListener('submit', submitFetch, false);
    downloadForm.addEventListener('submit', submitDownload, false);

    releaseChannel.addEventListener('change', (event) => {
        switchChannel(event.target.value);
    });
    currentChannel = releaseChannel.value;

    fileInput.addEventListener('change', (event) => {
        const file = event.target.files[0];
        if (file) {
            appendToLog('Selected file: "' + file.name + '"');
        }
    });

    clearVersions();
}

appendToLog("Preparing Web Flasher");
prepareListeners();

if (navigator.serial) {
    uploadForm.addEventListener('submit', submitUpload, false);
} else {
    appendToLog("Sorry. Error.");
    appendToLog("WebSerial not supported by this browser.");
    appendToLog("Try Chromium or Chrome or Edge.")
}
