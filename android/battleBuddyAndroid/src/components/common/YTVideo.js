import React from 'react';
import PropTypes from 'prop-types';
import {YouTubeStandaloneAndroid} from 'react-native-youtube';
import styled from 'styled-components/native';

const Thumbnail = styled.TouchableOpacity`
  background: red;
  /* prettier-ignore */
  aspectRatio: 1.77;
`;

const YTVideo = ({videoId}) => {
  const onPressHandler = () => {
    YouTubeStandaloneAndroid.playVideo({
      apiKey: 'AIzaSyBKtolM-loj-u-AIEh6HCH0BaL8UminqVI',
      lightboxMode: true,
      autoplay: true,
      videoId
    });
  };

  return <Thumbnail onPress={onPressHandler}></Thumbnail>;
};

/* <YouTube
      loop
      apiKey="AIzaSyBKtolM-loj-u-AIEh6HCH0BaL8UminqVI"
      videoId={videoId}
      style={{alignSelf: 'stretch', aspectRatio: 1.77}}
    /> */

YTVideo.propTypes = {
  videoId: PropTypes.string.isRequired
};

export default YTVideo;
