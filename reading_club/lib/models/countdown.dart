sealed class Countdown{
  const Countdown();
}

class Upcoming extends Countdown{
  final Duration duration;
  const Upcoming(this.duration);
}

class Started extends Countdown{
  final Duration duration;
  const Started(this.duration);
}

class Ended extends Countdown{
  const Ended();
}