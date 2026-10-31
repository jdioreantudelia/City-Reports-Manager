CC = gcc
CFLAGS = -Wall -g

all: city_manager city_hub monitor_reports scorer

city_manager: main.c library.h
	$(CC) $(CFLAGS) main.c -o city_manager

city_hub: city_hub.c library.h
	$(CC) $(CFLAGS) city_hub.c -o city_hub

monitor_reports: monitor_reports.c library.h
	$(CC) $(CFLAGS) monitor_reports.c -o monitor_reports

scorer: scorer.c library.h
	$(CC) $(CFLAGS) scorer.c -o scorer

clean:
	rm -f city_manager city_hub monitor_reports scorer .monitor_pid

.PHONY: all clean
