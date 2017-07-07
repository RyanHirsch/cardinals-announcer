const expect = require('expect');
const announce = require('../../announce');

describe('Announce', () => {
  it('gets day games when there is one', () => {
    return announce.getGamesForDate(new Date('2017-07-06 CDT'))
      .then(games => {
        expect(games.length).toEqual(1);
      });
  });
  it('gets no game when only night games', () => {
    return announce.getGamesForDate(new Date('2017-07-07 CDT'))
      .then(games => {
        expect(games.length).toEqual(0);
      });
  });
  it('gets the right game when there is a double header', () => {
    return announce.getGamesForDate(new Date('2017-06-13 CDT'))
      .then(games => {
        expect(games.length).toEqual(1);
      });
  });
  it('gets no games when it is the weekend', () => {
    return announce.getGamesForDate(new Date('2017-07-09 CDT'))
      .then(games => {
        expect(games.length).toEqual(0);
      });
  });
});
