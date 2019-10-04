import React, {useState} from 'react';
import styled from 'styled-components/native';
import I from 'react-native-vector-icons/MaterialCommunityIcons';

const Input = styled.TextInput.attrs({
  placeholderTextColor: 'rgba(255, 255, 255, 0.3)'
})`
  color: white;
  flex: 1;
`;

const SearchContainer = styled.View`
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
  // TODO: implement search query.
  const [searchTerm, setSearchTerm] = useState('');

  return (
    <SearchContainer>
      <Input
        placeholder="Search"
        onChangeText={(text) => setSearchTerm(text)}
        value={searchTerm}
        autoCorrect={false}
      />
      <Icon name="magnify" size={24} color="rgba(255, 255, 255, 0.3)" />
    </SearchContainer>
  );
};

export default Search;
