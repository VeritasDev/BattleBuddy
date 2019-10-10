import locales from '../../locales/en.json';

const localeString = (key) => {
  return locales[key] || key;
};

export default localeString;
