import React, { useState } from 'react';
import PropTypes from 'prop-types';
import styled, { css } from 'styled-components/native';
import { Ionicons } from '@expo/vector-icons';

const Input = styled.TextInput.attrs({
  placeholderTextColor: 'rgba(255, 255, 255, 0.3)',
})`
  color: white;
  text-decoration: underline;
`;

const SearchContainer = styled.View`
  position: relative;
  padding: 4px 50px 4px 16px;
  border: 1px solid rgba(255, 255, 255, 0.3);
  border-radius: 10px;
  margin-bottom: 20px;
`;

const Icon = styled(Ionicons)`
  position: absolute;
  top: 7;
  right: 16;
`;

const Search = props => {
  // TODO: implement search query.
  const [searchTerm, setSearchTerm] = useState('');

  return (
    <SearchContainer>
      <Input
        placeholder="Search"
        onChangeText={text => setSearchTerm(text)}
        value={searchTerm}
      />
      <Icon name="md-search" size={24} color="rgba(255, 255, 255, 0.3)" />
    </SearchContainer>
  );
};

Search.propTypes = {};

export default Search;
