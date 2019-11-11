import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components/native';
import {ImageBackground} from 'react-native';

const Text = styled.Text`
  color: white;
  text-transform: uppercase;
  font-size: 10px;
  font-weight: bold;
  padding: 3px 3px 3px 5px;
`;

const Container = styled.TouchableOpacity`
  width: 100px;
`;

const HPBarContainer = styled.View`
  border: 1px solid ${({blacked}) => (blacked ? 'red' : 'white')};
  text-align: center;
  position: relative;
`;

const HPText = styled.Text`
  color: ${({blacked}) => (blacked ? 'red' : 'white')};
  text-align: center;
  font-size: 10px;
`;

const Bar = styled.View`
  position: absolute;
  left: 0px;
  top: 0px;
  bottom: 0px;
  background: ${({color}) => color};
`;

const BodyZone = ({name, hp, maxHp, ...props}) => {
  const hpPercentage = (hp / maxHp) * 100;
  const hpDec = hpPercentage / 100;
  const blacked = hpPercentage === 0;
  let color;

  if (hpDec >= 0.7) {
    color = '#0C6316';
  } else if (hpDec >= 0.5) {
    color = '#596816';
  } else if (hpDec >= 0.3) {
    color = '#666100';
  } else if (hpDec >= 0.1) {
    color = '#664500';
  } else if (hpDec > 0) {
    color = '#FF0100';
  } else if (blacked) {
    color = 'black';
  }

  return (
    <Container {...props}>
      <ImageBackground
        resizeMode="contain"
        style={{width: 'auto', flexGrow: 0}}
        source={require('../../../assets/images/damage_calculator/body_zone_background.imageset/zone_background.png')}
      >
        <Text>{name}</Text>
      </ImageBackground>
      <HPBarContainer blacked={blacked} hp={hp} maxHp={maxHp}>
        <Bar color={color} width={`${hpPercentage}%`} />
        <HPText blacked={blacked}>
          {hp}/{maxHp}
        </HPText>
      </HPBarContainer>
    </Container>
  );
};

BodyZone.propTypes = {
  name: PropTypes.string.isRequired,
  hp: PropTypes.number.isRequired,
  maxHp: PropTypes.number.isRequired
};

export default BodyZone;
