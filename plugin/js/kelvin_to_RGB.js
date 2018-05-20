// adapted from: http://www.tannerhelland.com/4435/convert-temperature-rgb-algorithm-code/

function kelvin_to_RGB(kelvin) {

    kelvin = kelvin / 100;
    var red, blue, green;

    if (kelvin <= 66) {
        red = 255;
    } else {
        red = kelvin - 60;
        red = 329.698727466 * Math.pow(red, -0.1332047592);
        red = clamp_0_255(red);
    }

    if (kelvin <= 66) {
        green = kelvin;
        green = 99.4708025861 * Math.log(green) - 161.1195681661;
        green = clamp_0_255(green);
    } else {
        green = kelvin - 60;
        green = 288.1221695283 * Math.pow(green, -0.0755148492);
        green = clamp_0_255(green);
    }

    if (kelvin >= 66) {
        blue = 255;
    } else {
        if (kelvin <= 19) {
            blue = 0;
        } else {
            blue = kelvin - 10;
            blue = 138.5177312231 * Math.log(blue) - 305.0447927307;
            blue = clamp_0_255(blue);
        }
    }

    return [red, green, blue]
}

function clamp(number, min, max) {
    return Math.min(Math.max(number, min), max);
  }

function clamp_0_255(number) {
    return clamp(number, 0, 255)
}