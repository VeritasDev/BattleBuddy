import React, {useEffect} from 'react';
import styled from 'styled-components/native';
import {View, Image} from 'react-native';
import Icon from 'react-native-vector-icons/MaterialCommunityIcons';
import {theme} from '../../../components/Theme';
import BodyZone from '../../../components/learn/BodyZone';
import {useBallistics} from '../../../context/BallisticsProvider';
import {useNavigation} from 'react-navigation-hooks';

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

const DamageCalcScreen = () => {
  const {selectedAmmo, clearState} = useBallistics();
  const {navigate} = useNavigation();

  useEffect(() => {
    return clearState;
  }, []);

  return (
    <ImageBg
      resizeMode="contain"
      imageStyle={{opacity: 0.2}}
      source={require('../../../../assets/images/damage_calculator/health_calc_skeleton.imageset/skeleton.png')}
    >
      <View style={{flex: 1, height: '100%'}}>
        <BodyZone name="Head" hp={35} maxHp={35} style={{marginLeft: 'auto'}} />
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
            <BodyZone name="Thorax" hp={80} maxHp={80} />
          </View>
          <View
            style={{
              display: 'flex',
              flexDirection: 'row',
              justifyContent: 'space-around'
            }}
          >
            <BodyZone name="Right Arm" hp={60} maxHp={60} />
            <BodyZone name="Stomach" hp={70} maxHp={70} />
            <BodyZone name="Left Arm" hp={60} maxHp={60} />
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
              hp={65}
              maxHp={65}
              style={{marginRight: 20}}
            />
            <BodyZone name="Left Leg" hp={65} maxHp={65} />
          </View>
        </View>
        <View style={{marginTop: 'auto'}}>
          <HealthText>
            <Image
              source={require('../../../../assets/images/damage_calculator/health_star.imageset/health_star.png')}
            />
            435<Small> /435</Small>
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
              <BtnLabel>
                {(selectedAmmo && selectedAmmo.shortName) || 'Select Ammo'}
              </BtnLabel>
            </Button>
            <Icon name="refresh" color={theme.colors.orange} size={36} />
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
