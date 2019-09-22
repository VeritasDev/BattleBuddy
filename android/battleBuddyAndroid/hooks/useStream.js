import {useState, useEffect} from 'react';
import TheTeam from '../constants/TheTeam';

// TODO: Export both to environment file
const url = 'https://api.twitch.tv/helix/streams';
const clientId = '4fgs4wy7qqlk01ju7ad7vr3skcskqi';

const useStreams = (channelNames) => {
  const [state, setState] = useState({
    loading: true,
    error: null,
    channels: null
  });
  /**
   * Really not happy with current implementation.
   * I'd like to revisit this as soon as "The Team" data
   * comes in from the backend.
   * I know this isn't perfect right now but it will do for now.
   *
   * TODO: Refactor implementation once "The Team" data comes from the backend.
   */
  const getChannelInfo = async () => {
    if (!(channelNames instanceof Array)) {
      throw new Error('parameter supplied to "useStreams" is not an array');
    }

    const channels = [];

    Object.keys(TheTeam).forEach((k) => {
      if (channelNames.includes(k)) {
        channels.push(TheTeam[k]);
      }
    });

    let queryParams = '';

    channels.forEach((c, i) => {
      queryParams += i === 0 ? `?user_id=${c.userId}` : `&user_id=${c.userId}`;
    });

    const response = await fetch(url + queryParams, {
      method: 'GET',
      headers: {
        'CLIENT-ID': clientId
      }
    }).then((res) => res.json());

    response.data.map((x) => {
      const channel = channels.find((c) => c.userId === x.user_id);
      channel.live = true;
    });

    setState((prevState) => ({
      ...prevState,
      loading: false,
      channels
    }));
  };

  useEffect(() => {
    getChannelInfo();
  }, []);

  return state;
};

export default useStreams;
