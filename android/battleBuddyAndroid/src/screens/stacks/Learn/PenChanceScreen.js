import React, {useState, useEffect} from 'react';
import styled from 'styled-components/native';
import PenChanceButton from '../../../components/learn/PenChanceButton';
import {useNavigation} from 'react-navigation-hooks';
import {useBallistics} from '../../../context/BallisticsProvider';
import {Slider} from 'react-native-elements';

const View = styled.View`
  background: ${({theme}) => theme.colors.background};
  height: 100%;
  justify-content: center;
  flex: 1;
`;

const Padded = styled.View`
  padding: 0 30px;
  margin-top: 10px;
`;

const Text = styled.Text`
  color: white;
  font-size: 20px;
  font-family: sans-serif-light;
`;

const DurabilityText = styled(Text)`
  font-size: 24px;
`;

const HorizontalView = styled.View`
  flex-direction: row;
  justify-content: space-between;
  padding: 0 30px;
  align-items: center;
`;

const PenChance = styled.Text`
  color: ${({theme, green}) => (green ? 'greenyellow' : theme.colors.white)};
  font-size: 80;
  flex: 1;
  align-self: center;
  text-align: center;
  font-family: sans-serif-thin;
`;

const PenChanceScreen = () => {
  const {navigate} = useNavigation();
  const {ammo, armor, clearState} = useBallistics();
  const [durability, setDurability] = useState();
  const penChance = 95.7;

  useEffect(() => {
    if (armor) setDurability(armor.armor.durability);
  }, [armor]);

  useEffect(() => {
    // TODO: Add Ballistics Engine implementation.
  }, [durability]);

  useEffect(() => {
    return clearState;
  }, []);

  return (
    <View>
      <HorizontalView>
        <PenChance green={penChance !== null}>
          {penChance !== null ? `${penChance}%` : '__'}
        </PenChance>
      </HorizontalView>
      <HorizontalView style={{marginTop: 50}}>
        <PenChanceButton
          style={{marginRight: 20}}
          title={ammo ? ammo.shortName : 'Select\nAmmo'}
          item={ammo}
          onPress={() => navigate('Ammo')}
        />
        <PenChanceButton
          title={armor ? armor.shortName : 'Select\nArmor'}
          item={armor}
          onPress={() => navigate('Armor')}
        />
      </HorizontalView>
      {armor && ammo && (
        <>
          <HorizontalView style={{marginTop: 50}}>
            <DurabilityText>Durability</DurabilityText>
            <Text>
              {durability}/{armor.armor.durability}
            </Text>
          </HorizontalView>
          <Padded>
            <Slider
              maximumTrackTintColor="lightgrey"
              minimumTrackTintColor="greenyellow"
              thumbTintColor="white"
              step={1}
              value={durability}
              onValueChange={(value) => setDurability(value)}
              minimumValue={0}
              maximumValue={armor.armor.durability}
            />
          </Padded>
        </>
      )}
    </View>
  );
};

PenChanceScreen.navigationOptions = {
  title: 'Penetration Chance'
};

export default PenChanceScreen;
