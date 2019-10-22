import localeString from '../localeString';

describe('[UTIL] localeString', () => {
  test('Should take a key and return value from locales file', () => {
    const key = 'stab.damage';
    const expected = 'Stab Damage';
    const result = localeString(key);

    expect(result).toEqual(expected);
  });

  test('Should return value from "default" when key result is an object', () => {
    const key = 'armor';
    const expected = 'Armor';
    const result = localeString(key);

    expect(result).toEqual(expected);
  });

  test("Should return passed key if key doesn't exist in locales", () => {
    const key = 'this_is_bullshit';
    const expected = key;
    const result = localeString(key);

    expect(result).toEqual(expected);
  });

  test('Should throw typeof error', () => {
    expect(localeString).toThrow(
      `Expected "key" argument to be type of "string" but received: undefined`
    );
  });
});
