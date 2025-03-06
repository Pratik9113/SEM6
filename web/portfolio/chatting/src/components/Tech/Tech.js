import React from 'react';
import './Tech.css';
import cpp from '../../assets/c++icon.png';
import html from '../../assets/html.png';
import css from '../../assets/css.png';
import js from '../../assets/js.png';
import nodejs from '../../assets/nodejs.png';
import python from '../../assets/python.png';
import java from "../../assets/java.png";
import sql from "../../assets/sql.png"
import mongoDb from "../../assets/mongodb.png"
import reactjs from "../../assets/reactjs.png"
const Tech = () => {

  const skillTech = [
    { title: 'C++', image: cpp },
    { title: 'Python', image: python },
    { title: 'Java', image: java }
  ];

  const webTech = [
    { title: 'ReactJs', image: reactjs },
    { title: 'JavaScript', image: js },
    { title: 'NodeJs', image: nodejs },
    { title: 'HTML', image: html },
    { title: 'CSS', image: css },
  ];


  const Databases = [
    { title: 'sql', image: sql, },
    { title: 'MongoDb', image: mongoDb },
  ];

  return (
    <>
      <div className='skill'>
        <div className="container skill-caption">
          {/* <h2 className='col-12 mb-1 text-center'>Skill</h2> */}
        
        <div className="skillTech">
        <p style={{ textAlign: "center" }}>Technical Skills</p>
          <div className="container10">
            {skillTech.map((skill, index) => (
              <div key={index} className="box-skill">
                <img src={skill.image} alt={skill.title} className="skill-image" />
              </div>
            ))}
          </div>
        </div>

        <div className="webTech">
        <p style={{ textAlign: "center" }}>Web Technologies</p>
          <div className="container10">
            {webTech.map((skill, index) => (
              <div key={index} className="box-skill">
                <img src={skill.image} alt={skill.title} className="skill-image" />
              </div>
            ))}
          </div>
        </div>

        <div className="webTech">
        <p style={{ textAlign: "center" }}>Databases</p>
          <div className="container10">
            {Databases.map((skill, index) => (
              <div key={index} className="box-skill">
                <img src={skill.image} alt={skill.title} className="skill-image" />
              </div>
            ))}
          </div>
        </div>
      </div>
      </div>
    </>
  );
}

export default Tech;
