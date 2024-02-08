import React, { useState } from 'react';
import logo from './logo.svg';
import './App.css';
import Button from './Button';

function App() {
  const [increment, setIncrement] = useState(1);

  function click(){
    setIncrement(increment + 1)
  }
  return (
    <div className="App">
      <header className="App-header">
        <h1>{increment}</h1>
        <Button onClick={click} color={'red'}>Kjempefin tekst</Button>
        <Button color={'black'}><h1>KJEMPESTOR TEKST</h1></Button>
      </header>
    </div>
  );
}

export default App;