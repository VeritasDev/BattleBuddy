import React, {useState, useEffect} from 'react';
import PropTypes from 'prop-types';
import ScrollableContainer from '../components/common/ScrollableContainer';
import HorizontalCardBar from '../components/common/HorizontalCardBar';
import LoadingIndicator from '../components/common/LoadingIndicator';

const ItemScreen = ({navigation}) => {
  const [loading, setLoading] = useState(true);
  const {data} = navigation.state.params;

  useEffect(() => {
    // Just for loading testing purposes until fetching
    // data from backend is in place.
    // TODO: remove setTimeout
    setTimeout(() => {
      setLoading(false);
    }, 500);
  }, []);

  return loading ? (
    <LoadingIndicator />
  ) : (
    <ScrollableContainer>
      {data.map((category) => (
        <HorizontalCardBar
          title={category.title}
          items={category.items}
          key={category.title}
        />
      ))}
    </ScrollableContainer>
  );
};

ItemScreen.navigationOptions = (screenProps) => ({
  title: screenProps.navigation.getParam('text'),
  headerStyle: {
    backgroundColor: '#151515'
  },
  headerTintColor: '#FF491C',
  headerTitleStyle: {
    fontSize: 28
  }
});

ItemScreen.propTypes = {
  navigation: PropTypes.shape({
    state: PropTypes.shape({
      params: PropTypes.shape({
        text: PropTypes.string.isRequired,
        data: PropTypes.array.isRequired
      })
    })
  })
};

export default ItemScreen;
