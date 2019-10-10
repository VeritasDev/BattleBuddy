import React from 'react';
import PropTypes from 'prop-types';
import {TouchableOpacity} from 'react-native';
import {theme} from '../components/Theme';
import ScrollableContainer from '../components/common/ScrollableContainer';
import LoadingIndicator from '../components/common/LoadingIndicator';
import Search from '../components/common/Search';
import {useSearch} from '../context/SearchProvider';
import ItemCard from '../components/common/ItemCard';

const SearchScreen = () => {
  const {loading, data} = useSearch();

  if (loading) return <LoadingIndicator />;

  return (
    <ScrollableContainer>
      <Search />
      {data &&
        data.map((x) => {
          return (
            <TouchableOpacity key={x._id}>
              <ItemCard text={x.shortName} {...x} />
            </TouchableOpacity>
          );
        })}
    </ScrollableContainer>
  );
};

SearchScreen.navigationOptions = {
  title: 'Items',
  headerStyle: {
    backgroundColor: theme.colors.almostBlack
  },
  headerTintColor: theme.colors.orange,
  headerTitleStyle: {
    fontSize: 28
  }
};

SearchScreen.propTypes = {
  navigation: PropTypes.shape({
    navigate: PropTypes.func.isRequired
  }).isRequired
};

export default SearchScreen;
