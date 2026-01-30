const std = @import("std");

const Self = @This();

offset: i8,
seconds: u6,
minutes: u6,
hours: u5,
days: u8,
month: std.time.epoch.Month,
year: std.time.epoch.Year,

pub fn init(ofs: i8) Self {
    const now: u64 = @intCast(std.time.timestamp() + @as(i64, ofs) * 3600);
    const epoch_seconds = std.time.epoch.EpochSeconds{ .secs = now };
    const epoch_day = epoch_seconds.getEpochDay();
    const epoch_day_seconds = epoch_seconds.getDaySeconds();
    const epoch_year_day = epoch_day.calculateYearDay();
    const epoch_month_day = epoch_year_day.calculateMonthDay();

    const hours = epoch_day_seconds.getHoursIntoDay();
    const minutes = epoch_day_seconds.getMinutesIntoHour();
    const seconds = epoch_day_seconds.getSecondsIntoMinute();
    return .{
        .offset = ofs,
        .seconds = seconds,
        .minutes = minutes,
        .hours = hours,
        .days = epoch_month_day.day_index + 1,
        .month = epoch_month_day.month,
        .year = epoch_year_day.year,
    };
}

pub fn format(self: Self, w: *std.io.Writer) std.io.Writer.Error!void {
    try w.print("[{d:0>4}-{d:0>2}-{d:0>2} {d:0>2}:{d:0>2}:{d:0>2} UTC{s}{d}]", .{
        self.year,
        self.month,
        self.days,
        self.hours,
        self.minutes,
        self.seconds,
        if(self.offset>=0) "+" else "-",
        self.offset,
    });
}
