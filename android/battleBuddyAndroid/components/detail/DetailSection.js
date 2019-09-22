import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components/native';
import {ListItem} from 'react-native-elements';

const Section = styled.View`
  margin-bottom: 20px;
`;

const Text = styled.Text`
  color: white;
`;

const Title = styled(Text)`
  font-weight: bold;
  font-size: 20px;
  padding: 0 20px 10px;
`;

const Row = styled.View`
  flex: 1;
  flex-direction: row;
  justify-content: space-between;
`;

const Value = styled(Text)`
  font-weight: bold;
`;

const DetailSection = ({section}) => (
  <Section>
    <Title>{section.title}</Title>
    {section.rows.map((row) => {
      return (
        <ListItem
          key={row.key}
          title={
            <Row>
              <Text>{row.key}</Text>
              <Value>{row.value}</Value>
            </Row>
          }
          bottomDivider
          chevron={!row.hideChevron}
          containerStyle={{backgroundColor: 'black'}}
        />
      );
    })}
  </Section>
);

DetailSection.propTypes = {
  section: PropTypes.shape({
    title: PropTypes.string.isRequired,
    rows: PropTypes.arrayOf(
      PropTypes.shape({
        key: PropTypes.string.isRequired,
        value: PropTypes.string,
        hideChevron: PropTypes.bool
      })
    ).isRequired
  }).isRequired
};

export default DetailSection;
