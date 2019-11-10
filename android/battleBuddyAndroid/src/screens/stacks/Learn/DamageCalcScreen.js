import React, {useEffect, useState} from 'react';
import styled from 'styled-components/native';
import {View, Image} from 'react-native';
import Icon from 'react-native-vector-icons/MaterialCommunityIcons';
import {theme} from '../../../components/Theme';
import BodyZone from '../../../components/learn/BodyZone';
import {useBallistics} from '../../../context/BallisticsProvider';
import {useNavigation} from 'react-navigation-hooks';
import {NativeModules} from 'react-native';
import Ammo from '../../../models/Ammo';

const ImageBg = styled.ImageBackground`
  position: relative;
  height: 100%;
  background: ${({theme}) => theme.colors.black};
  padding: 20px;
`;

const HealthText = styled.Text`
  font-size: 36px;
  color: greenyellow;
  text-align: center;
  margin-bottom: 80px;
  display: flex;
  align-items: center;
`;

const Small = styled.Text`
  font-size: 24px;
  color: rgba(255, 255, 255, 0.5);
`;

const Button = styled.TouchableOpacity`
  background: ${({theme}) => theme.colors.orange};
  padding: 10px 0;
  border-radius: 4px;
  width: 100px;
`;
const BtnLabel = styled.Text`
  width: auto;
  color: white;
  font-weight: bold;
  text-align: center;
  font-size: 12px;
`;

const initialState = {
  head: 35,
  thorax: 80,
  rightArm: 60,
  stomach: 70,
  leftArm: 60,
  rightLeg: 65,
  leftLeg: 65,
  isAlive: true,
  totalHp: 435
};

const DamageCalcScreen = () => {
  const {ammo, clearState} = useBallistics();
  const [person, setPerson] = useState(initialState);
  const {navigate} = useNavigation();
  const ballisticsEngine = NativeModules.BallisticsEngine;

  useEffect(() => {
    return clearState;
  }, []);

  const processImpact = (bodyZone) => {
    if (ammo && person.isAlive) {
      const selectedAmmo = {
        ...new Ammo(ammo),
        didFrag: false
      };

      ballisticsEngine.damageCalculator(
        person,
        selectedAmmo,
        bodyZone,
        (value) => {
          console.log('Ammo', selectedAmmo);
          console.log('Current Person', person);
          console.log('New Person', value);
          setPerson(value);
        }
      );
    }
  };

  return (
    <ImageBg
      resizeMode="contain"
      imageStyle={{opacity: 0.2}}
      source={require('../../../../assets/images/damage_calculator/health_calc_skeleton.imageset/skeleton.png')}
    >
      <View style={{flex: 1, height: '100%'}}>
        <BodyZone
          name="Head"
          hp={Math.round(person.head)}
          maxHp={35}
          onPress={() => processImpact('HEAD')}
          style={{marginLeft: 'auto'}}
        />
        <View
          style={{
            flex: 1,
            height: '100%',
            flexDirection: 'column',
            justifyContent: 'space-around'
          }}
        >
          <View
            style={{
              display: 'flex',
              flexDirection: 'row',
              justifyContent: 'center'
            }}
          >
            <BodyZone
              name="Thorax"
              hp={Math.round(person.thorax)}
              maxHp={80}
              onPress={() => processImpact('THORAX')}
            />
          </View>
          <View
            style={{
              display: 'flex',
              flexDirection: 'row',
              justifyContent: 'space-around'
            }}
          >
            <BodyZone
              name="Right Arm"
              hp={Math.round(person.rightArm)}
              maxHp={60}
              onPress={() => processImpact('RIGHTARM')}
            />
            <BodyZone
              name="Stomach"
              hp={Math.round(person.stomach)}
              maxHp={70}
              onPress={() => processImpact('STOMACH')}
            />
            <BodyZone
              name="Left Arm"
              hp={Math.round(person.leftArm)}
              maxHp={60}
              onPress={() => processImpact('LEFTARM')}
            />
          </View>
          <View
            style={{
              display: 'flex',
              flexDirection: 'row',
              justifyContent: 'center'
            }}
          >
            <BodyZone
              name="Right Leg"
              hp={Math.round(person.rightLeg)}
              maxHp={65}
              onPress={() => processImpact('RIGHTLEG')}
              style={{marginRight: 20}}
            />
            <BodyZone
              name="Left Leg"
              hp={Math.round(person.leftLeg)}
              maxHp={65}
              onPress={() => processImpact('LEFTLEG')}
            />
          </View>
        </View>
        <View style={{marginTop: 'auto'}}>
          <HealthText>
            <Image
              source={require('../../../../assets/images/damage_calculator/health_star.imageset/health_star.png')}
            />
            {Math.round(person.totalHp)}
            <Small> /435</Small>
          </HealthText>
          <View
            style={{
              display: 'flex',
              justifyContent: 'space-between',
              flexDirection: 'row',
              alignItems: 'center'
            }}
          >
            <Button onPress={() => navigate('Ammo')}>
              <BtnLabel>{(ammo && ammo.shortName) || 'Select Ammo'}</BtnLabel>
            </Button>
            <Icon
              name="refresh"
              color={theme.colors.orange}
              size={36}
              onPress={() => setPerson(initialState)}
            />
          </View>
        </View>
      </View>
    </ImageBg>
  );
};

DamageCalcScreen.navigationOptions = {
  title: 'Damage Calculator'
};

export default DamageCalcScreen;
