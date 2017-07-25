const axios = require('axios');
const oneDay = 86400000;

function lambdaHandler(event, context, callback) {
  return getGamesForDate(new Date(Date.now() + oneDay), true)
    .then(games => {
      console.log('Games returned', games.length);
      return Promise.all(
        games.map(sendMessage)
      )
    })
    .then(() => {
      callback(null);
    })
    .catch(err => {
      console.error(err.message, url);
      callback(err);
    });
}

exports.handler = lambdaHandler;

function sendMessage(game) {
  const msg = `The ${game.home_team_name} are playing the ${game.away_team_name} @ ${game.home_time} tomorrow`;
  console.log(msg);
  return axios.post(process.env.URL, {
    text: `The ${game.home_team_name} are playing the ${game.away_team_name} @ ${game.home_time} tomorrow`
  })
}

function getDateSegment(d) {
  const year = d.getFullYear();
  const month = padDate(d.getMonth() + 1);
  const day = padDate(d.getDate());
  return `year_${year}/month_${month}/day_${day}`;
}

function padDate(val) {
  return val < 10 ? `0${val}` : `${val}`;
}

function getGamesForDate(date, ignoreWeekendGames) {
  if(ignoreWeekendGames) {
    switch(date.getDay()) {
      case 0:
      case 6:
        return Promise.resolve([]);
    }
  }
  const url = `http://gd2.mlb.com/components/game/mlb/${getDateSegment(date)}/miniscoreboard.json`;
  console.log('Getting games from', url);
  return axios.get(url)
    .then(({ data }) => {
      return data.data.games.game
        .filter(g => g.location === 'St. Louis, MO');
    });
}
exports.getGamesForDate = getGamesForDate;

function onlyDayGames(game) {
  const start = parseInt(game.home_time.split(':')[0], 10);
  return !(start < 9 && start > 6);
}
