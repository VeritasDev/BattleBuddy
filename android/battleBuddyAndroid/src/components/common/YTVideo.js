import React, {useState} from 'react';
import PropTypes from 'prop-types';
import YouTube from 'react-native-youtube';
import styled from 'styled-components/native';
import {Viewport} from '@skele/components';

/**
 * Because of Android's limited Youtube API we can only have
 * on Youtube player active at the same time. To work around this,
 * I mount/unmount when component is about to hit the viewport.
 *
 * Check for more info: https://github.com/inProgress-team/react-native-youtube#multiple-youtube--instances-on-android
 * Check Viewport Tacker: https://netcetera.gitbooks.io/skele/packages/components/
 */

const View = styled.View`
  /* prettier-ignore */
  aspectRatio: 1.77;
`;

const ViewportAwareView = Viewport.Aware(View);

const YTVideo = ({videoId}) => {
  const [show, setShow] = useState(false);

  return (
    <ViewportAwareView
      preTriggerRatio={0.5}
      onViewportEnter={() => setShow(true)}
      onViewportLeave={() => setShow(false)}
    >
      {show && (
        <YouTube
          apiKey="AIzaSyBKtolM-loj-u-AIEh6HCH0BaL8UminqVI"
          videoId={videoId}
          style={{alignSelf: 'stretch', aspectRatio: 1.77}}
        />
      )}
    </ViewportAwareView>
  );
};

YTVideo.propTypes = {
  videoId: PropTypes.string.isRequired
};

export default YTVideo;
