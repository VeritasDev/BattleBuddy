import React, {useState} from 'react';
import styled from 'styled-components/native';
import I from 'react-native-vector-icons/MaterialCommunityIcons';
import {useSearch} from '../../context/SearchProvider';
import {useNavigation} from 'react-navigation-hooks';

const Input = styled.TextInput.attrs({
  placeholderTextColor: 'rgba(255, 255, 255, 0.3)',
  selectionColor: 'red'
})`
  color: white;
  flex: 1;
  height: 40px;
`;

const Container = styled.View`
  position: relative;
  padding-left: 8px;
  border-radius: 10px;
  margin-bottom: 10px;
  flex: 1;
  flex-direction: row;
  align-items: center;
  background: ${({theme}) => theme.colors.black};
`;

const Icon = styled(I)`
  margin-right: 8px;
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
        placeholder="Search..."
        onChangeText={(text) => setState(text)}
        value={state}
        autoCorrect={false}
        selectionColor="red"
        onEndEditing={handleSubmit}
        keyboardAppearance="dark"
        returnKeyLabel="Search"
      />
      <Icon name="magnify" size={24} color="rgba(255, 255, 255, 0.3)" />
    </Container>
  );
};

export default Search;
