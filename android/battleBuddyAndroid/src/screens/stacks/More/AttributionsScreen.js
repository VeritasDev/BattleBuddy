import React from 'react';
import styled from 'styled-components/native';
import {Linking} from 'react-native';
import Socials from '../../../constants/Socials';
import {ListItem} from 'react-native-elements';

const ScrollView = styled.ScrollView`
  background: ${({theme}) => theme.colors.background};
`;

const Title = styled.Text`
  font-size: 18px;
  font-weight: bold;
  color: white;
`;

const SubTitle = styled.Text`
  color: white;
  margin-top: 4px;
`;

const AttributionsScreen = () => {
  // Placeholder data until data comes from backend
  const DATA = [
    {
      title: 'Battlestate Games Limited',
      subtitle: `Special thanks to Nikita for his support of this app, and to all the folks at BSG for their hard work and dedication in building the best first-person shooter of all time.`,
      image: require('../../../../assets/images/branding_and_logos/veritas_logo.png'),
      onPress: () => Linking.openURL(Socials.website)
    },
    {
      title: 'Morphy2k & Tarkov Database',
      subtitle: `This project wouldn't have been possible without the fantastic dev work done by Morphy on the Tarkov Database and underlying API`,
      image: require('../../../../assets/images/branding_and_logos/veritas_logo.png'),
      onPress: () => Linking.openURL(Socials.website)
    }
  ];

  return (
    <ScrollView>
      {DATA.map((attribution) => (
        <ListItem
          key={attribution.title}
          title={<Title>{attribution.title}</Title>}
          subtitle={<SubTitle>{attribution.subtitle}</SubTitle>}
          containerStyle={{backgroundColor: 'black', marginBottom: 20}}
          titleStyle={{color: 'white'}}
          subtitleStyle={{color: 'white'}}
          chevron
          bottomDivider
          topDivider
        />
      ))}
    </ScrollView>
  );
};

AttributionsScreen.navigationOptions = {
  title: 'Attributions'
};

export default AttributionsScreen;
