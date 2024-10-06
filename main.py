from dotenv import load_dotenv

from agent.agent import init_graph, print_event


def main():
    load_dotenv()

    graph = init_graph()

    # user_input = "Recommend: 1a"
    user_input = "Update: 1a"
    events = graph.stream(
        {"messages": ("user", user_input)}, stream_mode="values"
    )

    _printed = set()
    for event in events:
        print_event(event, _printed)


if __name__ == "__main__":
    main()
