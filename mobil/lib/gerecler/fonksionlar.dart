int dateTimeToIntId(DateTime dt) =>
    int.parse("${dt.year - 2020}${dt.month}${dt.day}${dt.minute}${dt.minute}");
