#include "pico/stdlib.h"
#include "hardware/i2c.h"

#include "ssd1306.h"

void setup_gpios(void);

int main() {
    stdio_init_all();

    setup_gpios();

    ssd1306_t disp;
    disp.external_vcc=false;
    ssd1306_init(&disp, 128, 64, 0x3C, i2c1);
    ssd1306_clear(&disp);
    ssd1306_draw_string(&disp, 8, 24, 2, "test");
    ssd1306_show(&disp);

    return 0;
}

void setup_gpios(void) {
    i2c_init(i2c1, 400000);
    gpio_set_function(14, GPIO_FUNC_I2C);
    gpio_set_function(15, GPIO_FUNC_I2C);
    gpio_pull_up(14);
    gpio_pull_up(15);
}