import React from 'react';
import styled from 'styled-components/native';
import PenChanceButton from '../../../components/learn/PenChanceButton';

const View = styled.View`
  background: ${({theme}) => theme.colors.background};
  height: 100%;
  justify-content: center;
  flex: 1;
`;

const HorizontalView = styled.View`
  flex-direction: row;
  justify-content: center;
  flex: 1;
`;

const PenChance = styled.Text`
  color: ${({theme}) => theme.colors.white};
  font-size: 80;
  flex: 1;
  align-self: center;
  text-align: center;
`;

const PenChanceScreen = () => {
  return (
    <View>
      <HorizontalView>
        <PenChance>_</PenChance>
      </HorizontalView>
      <HorizontalView>
        <PenChanceButton title="Select Ammo" />
        <PenChanceButton title="Select Armor" />
      </HorizontalView>
    </View>
  );
};

PenChanceScreen.navigationOptions = {
  title: 'Penetration Chance'
};

export default PenChanceScreen;
