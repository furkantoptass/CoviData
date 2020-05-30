const express = require('express');
const app = express();
const got = require('got');
const CountryData = require('./model/countryData.js')

app.use(express.json());
app.use(express.urlencoded({extended: true}));


app.get('/', async function(req, res) {
  console.log("Retrieving Covid-19 data...\n");
  try {
    let url = "https://ibrahim39.github.io/covid19/timeseries.json";
    const response = await got(url, {responseType: 'json', retry: 3});
    let covid19Data = {};
    if (response.statusCode === 200) {
      const countries = response.body;
      Object.keys(countries).forEach(function (key) {
        covid19Data[key] = [];
        for (let i = 0; i < countries[key].length; i++) {
          let data = countries[key][i];
          let prevData = i > 0 ? countries[key][i - 1] : null;
          let date = data.date;
          covid19Data[key].push({
            date: date,
            confirmed: data.confirmed,
            deaths: data.deaths,
            recovered: data.recovered,
            sick: data.confirmed - data.deaths - data.recovered,
            todayConfirmed: i === 0 ? data.confirmed : data.confirmed - prevData.confirmed,
            todayDeaths: i === 0 ? data.deaths : data.deaths - prevData.deaths,
            todayRecovered: i === 0 ? data.recovered : data.recovered - prevData.recovered,
          })
        }
      })

      let myMap = new Map();
      for (let i = 0; i < countries["Turkey"].length; i++) {
        let date = countries["Turkey"][i].date;
        myMap.set(date, new CountryData(0, 0, 0, 0, 0, 0, 0));
      }

      Object.keys(countries).forEach(function (key) {
        for (let i = 0; i < countries[key].length; i++) {
          let data = countries[key][i];
          let date = data.date;
          let prevDate = i > 0 ? countries[key][i - 1].date : null;
          let confirmed = myMap.get(date).confirmed + data.confirmed;
          let deaths = myMap.get(date).deaths + data.deaths;
          let recovered = myMap.get(date).recovered + data.recovered;
          let sick = myMap.get(date).sick + (data.confirmed - data.deaths - data.recovered);
          let todayConfirmed = i === 0 ? confirmed : myMap.get(date).confirmed - myMap.get(prevDate).confirmed;
          let todayDeaths = i === 0 ? deaths : myMap.get(date).deaths - myMap.get(prevDate).deaths;
          let todayRecovered = i === 0 ? recovered : myMap.get(date).recovered - myMap.get(prevDate).recovered;
          myMap.set(date, new CountryData(confirmed, deaths, recovered, sick, todayConfirmed, todayDeaths, todayRecovered));
        }
      })

      covid19Data["Global"] = [];
      myMap.forEach(function (value, key) {
        covid19Data["Global"].push({
          date: key,
          confirmed: value.totalConfirmed,
          deaths: value.totalDeaths,
          recovered: value.totalRecovered,
          sick: value.totalSick,
          todayConfirmed: value.totalTodayConfirmed,
          todayDeaths: value.totalTodayDeaths,
          todayRecovered: value.totalTodayRecovered
        })
      })

      res.json(covid19Data);
    } else {
      covid19Data = {statusCode: response.statusCode};

      res.json(covid19Data);
    }
  } catch (err) {
    return err;
  }
})


app.listen(8080, "0.0.0.0", () => console.log("\nServer started on port: 8080\n"));
