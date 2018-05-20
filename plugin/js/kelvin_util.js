function normalizeColor(rgb) {
    return [rgb[0] / 255, rgb[1] / 255, rgb[2] / 255];
}

function to_255(value) {
    return Math.floor(value * 255);
}

function to_rgb255(rgb) {
    return [to_255(rgb[0]), to_255(rgb[1]), to_255(rgb[2])];
}

function valToHex(v) { 
    var hex = v.toString(16);
    return hex.length == 1 ? "0" + hex : hex;
}

function rgbToHex(rgb) { 
    var hex = [];
    for (var i = 0; i < 3; i++) {
        hex[i] = valToHex(rgb[i]);
    };
    return "#" + hex[0] + hex[1] + hex[2];
}