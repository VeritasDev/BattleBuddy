import React from 'react';
import styled from 'styled-components/native';
import {Linking} from 'react-native';
import Socials from '../../constants/Socials';
import CustomListItem from '../../components/settings/CustomListItem';
import useStreams from '../../hooks/useStream';

const SectionTitle = styled.Text`
  color: ${({theme}) => theme.colors.gray};
  text-transform: uppercase;
  margin-left: 10px;
  margin-top: 20px;
  margin: 20px 0 5px 10px;
`;

const ScrollView = styled.ScrollView`
  background: ${({theme}) => theme.colors.background};
`;

const VeritasScreen = () => {
  const {channels} = useStreams(['veritas']);

  const channelLive = channels && channels[0].live;

  // Placeholder data until data comes from backend
  const DATA = [
    {
      title: 'Social',
      items: [
        {
          title: 'Watch Live on Twitch',
          image: require('../../assets/images/branding_and_logos/twitch.png'),
          subtitle: channelLive ? 'Live now!' : undefined,
          subtitleStyle: {color: 'red'},
          onPress: () => Linking.openURL(Socials.twitch)
        },
        {
          title: 'Watch on YouTube',
          image: require('../../assets/images/branding_and_logos/youtube.png'),
          onPress: () => Linking.openURL(Socials.youtube)
        },
        {
          title: 'Stay Up to Date',
          image: require('../../assets/images/branding_and_logos/twitter.png'),
          onPress: () => Linking.openURL(Socials.twitter)
        },
        {
          title: 'Join Our Community Discord',
          image: require('../../assets/images/branding_and_logos/discord.png'),
          onPress: () => Linking.openURL(Socials.discord)
        },
        {
          title: 'Media on Instagram',
          image: require('../../assets/images/branding_and_logos/instagram.png'),
          onPress: () => Linking.openURL(Socials.instagram)
        },
        {
          title: 'More about Veritas',
          image: require('../../assets/images/branding_and_logos/veritas_logo.png'),
          onPress: () => Linking.openURL(Socials.website)
        }
      ]
    },
    {
      title: 'My Music',
      items: [
        {
          title: 'Listen on Spotify',
          image: require('../../assets/images/branding_and_logos/spotify.png'),
          onPress: () => Linking.openURL(Socials.spotify)
        },
        {
          title: 'Listen on Soundcloud',
          image: require('../../assets/images/branding_and_logos/soundcloud.png'),
          onPress: () => Linking.openURL(Socials.soundcloud)
        }
      ]
    }
  ];

  return (
    <ScrollView>
      {DATA.map((section) => {
        return (
          <React.Fragment key={section.title}>
            <SectionTitle>{section.title}</SectionTitle>
            {section.items.map((item, index) => (
              <CustomListItem item={item} key={index} />
            ))}
          </React.Fragment>
        );
      })}
    </ScrollView>
  );
};

VeritasScreen.navigationOptions = {
  title: 'Veritas',
  headerStyle: {
    backgroundColor: '#191919'
  },
  headerTintColor: '#FF491C',
  headerTitleStyle: {
    fontSize: 28
  }
};

export default VeritasScreen;
