class CountryData {
  constructor(confirmed, deaths, recovered, sick, todayConfirmed, todayDeaths, todayRecovered) {
    this.confirmed = confirmed;
    this.deaths = deaths;
    this.recovered = recovered;
    this.sick = sick;
    this.todayConfirmed = todayConfirmed;
    this.todayDeaths = todayDeaths;
    this.todayRecovered = todayRecovered;
  }

  get totalConfirmed() {
    return this.confirmed;
  }

  get totalDeaths() {
    return this.deaths;
  }

  get totalRecovered() {
    return this.recovered;
  }

  get totalSick() {
    return this.sick;
  }

  get totalTodayConfirmed() {
    return this.todayConfirmed;
  }

  get totalTodayDeaths() {
    return this.todayDeaths;
  }

  get totalTodayRecovered() {
    return this.todayRecovered;
  }
}

module.exports = CountryData
