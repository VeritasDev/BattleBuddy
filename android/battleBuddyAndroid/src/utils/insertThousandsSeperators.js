const insertThousandsSeperators = (num) => {
  let num_parts = num.toString().split('.');
  num_parts[0] = num_parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, '.');
  return num_parts.join('.');
};

export default insertThousandsSeperators;
