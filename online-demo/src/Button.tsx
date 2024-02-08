import { ReactNode } from 'react';

type Props = {
    children: ReactNode,
    color: string,
    onClick?: () => void
};

function Button(props: Props) {
    return (
        <button
            style={{ border: '10px solid green', borderColor: props.color, padding: 20, borderRadius: 20 }}
            onClick={props.onClick}
        >
            {props.children}
        </button>
    );
}

export default Button;