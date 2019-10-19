import getDescendantProp, {ParamError} from '../getDescendantProp';

describe('[UTIL] getDescendantProp', () => {
  const obj = {
    armor: {
      material: 'Aluminium',
      default: 'Armor'
    },
    firearm: 'Firearm',
    grenade: {
      damage: 50
    }
  };

  test('Should return descendant value from object', () => {
    const expected = obj.armor.material;
    const key = 'armor.material';
    const result = getDescendantProp(obj, key);

    expect(result).toEqual(expected);
  });

  test('Should throw on missing parameters', () => {
    const key = 'armor';

    expect(getDescendantProp).toThrow(ParamError);
    expect(() => getDescendantProp(undefined, key)).toThrow(
      'argument passed must be of type object but received: undefined'
    );
    expect(() => getDescendantProp(obj, undefined)).toThrow(
      'argument passed must be of type string but received: undefined'
    );
  });
});
