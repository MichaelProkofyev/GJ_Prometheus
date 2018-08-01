using System.Collections;
using System.Collections.Generic;
using UnityEngine;

enum GameState
{
    QUESTION,
    COMMAND,
    REVEAL,
    DECISION,
    
}

public class GameController : MonoBehaviour {

    public TMPro.TextMeshProUGUI mainText;
    public ParticleSystem particles;

    GameState state = GameState.QUESTION;

    GameState State 
    {
        get { return state; }
        set 
        {
            humanRenderer.material.SetFloat("_NoiseLerp", 0);
            particles.enableEmission = false;
            switch (value)
            {
                case GameState.QUESTION:
                    mainText.text = "Got a match?";
                    break;
                case GameState.COMMAND:
                    mainText.text = "SHED THY CLOTHES!!!";
                    break;
                case GameState.REVEAL:
                    humanRenderer.material.SetFloat("_NoiseLerp", 1);
                    particles.enableEmission = true;
                    mainText.text = "...";
                    break;
                case GameState.DECISION:

                    mainText.text = "Does he posess a match?";
                    break;
            }
            state = value;
        }

    }
    
    [SerializeField] private Renderer humanRenderer = null;


	// Use this for initialization
	void Start () {
        State = GameState.QUESTION;
	}
	
	// Update is called once per frame
	void Update () {
		switch (state)
        {

            case GameState.QUESTION:
                if (Input.GetKeyDown(KeyCode.Space))
                {
                    State = GameState.COMMAND;
                }
                break;
            case GameState.COMMAND:
                if (Input.GetKeyDown(KeyCode.Space))
                {
                    State = GameState.REVEAL;
                }
                break;
            case GameState.REVEAL:

                //TODO: Remove manual control, add delay & transition to decision
                if (Input.GetKeyDown(KeyCode.Space))
                {
                    State = GameState.DECISION;
                }
                break;
            case GameState.DECISION:
                break;
        }


	}
}
