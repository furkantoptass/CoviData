const got = require('got');
const CountryData = require('./model/countryData.js')
const PROTO_PATH = __dirname + '/proto/helloworld.proto';
const grpc = require('grpc');
const protoLoader = require('@grpc/proto-loader');
const packageDefinition = protoLoader.loadSync(
  PROTO_PATH,
  {
    keepCase: true,
    longs: String,
    enums: String,
    defaults: true,
    oneofs: true
  });
const hello_proto = grpc.loadPackageDefinition(packageDefinition).helloworld;


async function sayHello(call, callback) {
    callback(null, {message: await replyMessage()});
}

async function replyMessage() {
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

      return JSON.stringify(covid19Data);
    } else {
      covid19Data = {statusCode: response.statusCode};

      return JSON.stringify(covid19Data);
    }
  } catch (err) {
    return err;
  }
}

function main() {
  const server = new grpc.Server();
  server.addService(hello_proto.Greeter.service,
        {
            SayHello: sayHello,
        });
    server.bind('0.0.0.0:8080', grpc.ServerCredentials.createInsecure());
    console.log("\nServer started on port: 8080\n");
    server.start();
}

main();
