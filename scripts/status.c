#include <ncurses.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

void print_line(int line, const char *label, const char *value,
                int color_pair) {
  int label_len = strlen(label);
  int value_len = strlen(value);
  int dash_count = COLS - label_len - value_len;

  move(line, 0);
  attron(COLOR_PAIR(1));
  printw("%s", label);
  attroff(COLOR_PAIR(1));

  attron(COLOR_PAIR(3));
  for (int i = 0; i < dash_count; i++) {
    printw("-");
  }
  attroff(COLOR_PAIR(3));

  attron(COLOR_PAIR(color_pair));
  printw("%s", value);
  attroff(COLOR_PAIR(color_pair));
}

int main() {
  initscr();
  curs_set(0);
  noecho();
  cbreak();
  nodelay(stdscr, TRUE);

  // Enable colors
  start_color();
  init_pair(1, COLOR_CYAN, COLOR_BLACK);  // Labels
  init_pair(2, COLOR_GREEN, COLOR_BLACK); // Values
  init_pair(3, COLOR_WHITE, COLOR_BLACK); // Dashes
  init_pair(4, COLOR_RED, COLOR_BLACK);   // Low battery

  int ch;

  while (1) {
    clear();

    char workspace[10] = {0}, time_str[10] = {0}, volume[10] = {0},
         battery[10] = {0}, backlight[10] = {0};

    // Workspace
    FILE *ws = popen("bspc query -D -d focused --names", "r");
    if (ws) {
      fgets(workspace, sizeof(workspace), ws);
      pclose(ws);
    }
    workspace[strcspn(workspace, "\n")] = 0;

    // Time
    FILE *tm = popen("date +%H:%M", "r");
    if (tm) {
      fgets(time_str, sizeof(time_str), tm);
      pclose(tm);
    }
    time_str[strcspn(time_str, "\n")] = 0;

    // Volume
    FILE *vol = popen(
        "pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | tr -d '%'",
        "r");
    if (vol) {
      fgets(volume, sizeof(volume), vol);
      pclose(vol);
    }
    volume[strcspn(volume, "\n")] = 0;

    // Battery
    FILE *bat = popen("cat /sys/class/power_supply/BAT0/capacity", "r");
    if (bat) {
      fgets(battery, sizeof(battery), bat);
      pclose(bat);
    }
    battery[strcspn(battery, "\n")] = 0;

    // Backlight
    FILE *bl = popen("brightnessctl -m | cut -d, -f4 | tr -d '%'", "r");
    if (bl) {
      fgets(backlight, sizeof(backlight), bl);
      pclose(bl);
    }
    backlight[strcspn(backlight, "\n")] = 0;

    print_line(0, "you are on workspace ", workspace, 2);
    print_line(1, "it is currently ", time_str, 2);
    print_line(2, "volume is at ", volume, 2);

    int bat_level = atoi(battery);
    int bat_color = (bat_level < 20) ? 4 : 2; // Red if low, green otherwise
    print_line(3, "battery is at ", battery, bat_color);

    print_line(4, "backlight is at ", backlight, 2);

    refresh();

    ch = getch();
    if (ch == 'q' || ch == 27)
      break;

    struct timeval tv = {0, 50000};
    select(0, NULL, NULL, NULL, &tv);
  }

  endwin();
  return 0;
}
