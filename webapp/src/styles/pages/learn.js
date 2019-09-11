import styled from 'styled-components';

export const LearnPageWrapper = styled.div`
    display: flex;
    flex-direction: column;
`;

export const LearnPageInput = styled.input`
    display: ${({ isHidden }) => (isHidden ? "none" : "block")};
`;