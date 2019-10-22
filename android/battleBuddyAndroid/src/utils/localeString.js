import locales from '../../locales/en.json';
import getDescendantProp from './getDescendantProp.js';

const localeString = (key) => {
  if (typeof key !== 'string')
    throw new TypeError(
      `Expected "key" argument to be type of "string" but received: ${key}`
    );
  const value = getDescendantProp(locales, key);

  if (!value) return key;

  if (typeof value === 'object') {
    return value.default ? value.default : value;
  }

  return value;
};

export default localeString;
