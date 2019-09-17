import React from 'react';
import ScrollableContainer from '../../components/common/ScrollableContainer';
import HorizontalCardBar from '../../components/common/HorizontalCardBar';
import firearmsData from '../../test-data/firearms';

const FirearmsScreen = () => {
  return (
    <ScrollableContainer>
      {firearmsData.map(data => (
        <HorizontalCardBar
          title={data.title}
          items={data.items}
          key={data.title}
        />
      ))}
    </ScrollableContainer>
  );
};

FirearmsScreen.navigationOptions = {
  title: 'Firearms',
  headerStyle: {
    backgroundColor: '#151515',
  },
  headerTintColor: '#FF491C',
  headerTitleStyle: {
    fontSize: 28,
  },
};

export default FirearmsScreen;
