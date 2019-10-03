import React from 'react';
import styled from 'styled-components/native';

const ScrollView = styled.ScrollView`
  background: ${({theme}) => theme.colors.background};
`;

const DamageCalcScreen = () => {
  return <ScrollView></ScrollView>;
};

DamageCalcScreen.navigationOptions = {
  title: 'Damage Calculator',
  headerStyle: {
    backgroundColor: '#191919'
  },
  headerTintColor: '#FF491C',
  headerTitleStyle: {
    fontSize: 28
  }
};

export default DamageCalcScreen;
