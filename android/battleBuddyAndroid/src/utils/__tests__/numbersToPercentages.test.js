import numbersToPercentages from '../numbersToPercentage';

describe('[UTIL] numbersToPercentages', () => {
  test('Should return array with percentages', () => {
    const array = [1, 2, 3, 4, 5];
    const expected = [0, 25, 50, 75, 100];
    const result = numbersToPercentages(array);

    expect(result).toEqual(expected);
  });

  test('Should operate normally with mixed negative and positive numbers', () => {
    const array = [-1, -2, -3, -4, -5];
    const expected = [100, 75, 50, 25, 0];
    const result = numbersToPercentages(array);

    expect(result).toEqual(expected);
  });
});
