import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components/native';
import SectionHeader from './SectionHeader';
import SectionItems from './SectionItems';
import localeString from '../../utils/localeString';

const SectionList = styled.SectionList`
  padding: 20px 0;
  background: ${({theme}) => theme.colors.background};
`;

const ItemSectionList = ({data, localized}) => {
  const filteredData = data.filter((x) => x.data.length);

  return (
    <SectionList
      initialNumToRender={4}
      sections={filteredData.map((x) => ({...x, data: [x.data]}))}
      keyExtractor={(item, index) => index}
      renderItem={({item}) => <SectionItems items={item} />}
      renderSectionHeader={({section: {title}}) => (
        <SectionHeader>{localized ? localeString(title) : title}</SectionHeader>
      )}
    />
  );
};

ItemSectionList.propTypes = {
  data: PropTypes.array.isRequired,
  localized: PropTypes.bool
};

export default ItemSectionList;
