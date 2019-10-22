import calculateRedValue from '../calculateRedValue';

describe('[UTIL] calculateRedValue', () => {
  test('Should return max value splitted in 5', () => {
    const array = [1, 2, 3, 4, 5];
    const expected = [255, 191, 128, 64, 0];
    const result = array.map((x, i) => calculateRedValue(i, array.length));

    expect(result).toEqual(expected);
  });

  test('Should return 255 and 0', () => {
    const array = [1, 2];
    const expected = [255, 0];
    const result = array.map((x, i) => calculateRedValue(i, array.length));

    expect(result).toEqual(expected);
  });

  test('Should return 255', () => {
    const array = [1];
    const expected = [255];
    const result = array.map((x, i) => calculateRedValue(i, array.length));

    expect(result).toEqual(expected);
  });

  // TODO: include more tests
});
