/**
 * Funciton that calculates percentage of each number in array for use in bar charts
 * for example.
 *
 * @param {[Number]} array - Array of numbers that will be converted into percentages
 *
 * @returns {[Number]}
 */
const numbersToPercentages = (array) => {
  const max = Math.max(...array);
  const min = Math.min(...array);
  const minAllowed = 0;
  const maxAllowed = 100;

  if (isNaN(min) || isNaN(max)) {
    console.log(array);
  }

  const formula = (num) => {
    return minAllowed + ((num - min) / (max - min)) * (maxAllowed - minAllowed);
  };

  return array.map(formula);
};

export default numbersToPercentages;
