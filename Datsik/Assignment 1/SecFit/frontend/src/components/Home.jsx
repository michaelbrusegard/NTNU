import {Container, Stack} from "@mui/material";
import fitness from '../assets/img/fitness.jpg';


function Home (){
    return(
        <Container>
            <Stack>
                <h2 className="">Welcome to SecFit!</h2>
                <p>SecFit (coming from "Secure" and "Fitness") is the most secure fitness logging app on the net.
                    You can conveniently log a workout using either our website or our app. You can also view and comment on others'
                    workouts!
                </p>
                <img src={fitness} className="img-fluid" alt="DUMBBELLS"/>
            </Stack>
        </Container>
)
}

export default Home;