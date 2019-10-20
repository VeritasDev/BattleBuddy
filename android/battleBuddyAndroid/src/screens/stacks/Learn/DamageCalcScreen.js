import React from 'react';
import styled from 'styled-components/native';

const ScrollView = styled.ScrollView`
  background: ${({theme}) => theme.colors.background};
`;

const DamageCalcScreen = () => {
  return <ScrollView></ScrollView>;
};

DamageCalcScreen.navigationOptions = {
  title: 'Damage Calculator'
};

export default DamageCalcScreen;
