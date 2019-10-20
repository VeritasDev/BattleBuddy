import React, {useState} from 'react';
import styled from 'styled-components/native';
import I from 'react-native-vector-icons/MaterialCommunityIcons';
import {useSearch} from '../../context/SearchProvider';
import {useNavigation} from 'react-navigation-hooks';

const Input = styled.TextInput.attrs({
  placeholderTextColor: 'rgba(255, 255, 255, 0.3)'
})`
  color: white;
  flex: 1;
`;

const Container = styled.View`
  position: relative;
  padding-left: 8px;
  border: 1px solid rgba(255, 255, 255, 0.3);
  border-radius: 10px;
  margin-bottom: 20px;
  flex: 1;
  flex-direction: row;
  align-items: center;
`;

const Icon = styled(I)`
  margin-right: 16px;
  margin-left: 8px;
`;

const Search = () => {
  const {setSearchTerm, searchTerm} = useSearch();
  const {navigate} = useNavigation();
  const [state, setState] = useState(searchTerm);

  const handleSubmit = () => {
    if (state.length) {
      setSearchTerm(state);
      navigate('Search', {searchTerm: state});
    }
  };

  return (
    <Container>
      <Input
        placeholder="Search"
        onChangeText={(text) => setState(text)}
        value={state}
        autoCorrect={false}
        onEndEditing={handleSubmit}
      />
      <Icon name="magnify" size={24} color="rgba(255, 255, 255, 0.3)" />
    </Container>
  );
};

export default Search;
