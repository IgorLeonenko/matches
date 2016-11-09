<template>
  <div id='match'>
    <h2>
      Match {{match.status}}
    </h2>
    <table v-if='match'>
      <thead>
        <tr>
          <td>Home team</td>
          <td>Invited team</td>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>
            <p>Name: {{match.home_team.name}}</p>
            <p v-if="match.status == 'in game'">
              <label for="home_team_score">Score: </label>
              <input type="number" v-model="match.home_team_score" name="home_team_score">
              </input>
            </p>
            <p v-else>
              Score: {{match.home_team_score}}
            </p>
            <p>Players:
              <ul v-for='user in match.home_team.users'>
                <li>{{user.username}}</li>
              </ul>
            </p>
          </td>
          <td>
            <p>Name: {{match.invited_team.name}}</p>
            <p v-if="match.status == 'in game'">
              <label for="invited_team_score">Score: </label>
              <input type="number" v-model="match.invited_team_score" name="invited_team_score">
              </input>
            </p>
            <p v-else>Score: {{match.invited_team_score}}</p>
            <p>Players:
              <ul v-for='user in match.invited_team.users'>
                <li>{{user.username}}</li>
              </ul>
            </p>
          </td>
        </tr>
      </tbody>
    </table>
    <button type='button' v-if="match.status == 'prepare'" @click="playMatch()">
      Play match
    </button>
    <button type='button' v-if="match.status == 'in game'" @click="finishMatch()">
      Finish match
    </button>
    <button type='button' @click="goBack()">Back</button>
  </div>
</template>

<script>
  import { router } from '../main'
  export default {
    name: 'Match',
    computed: {
      match () {
        var match = this.$store.state.matches.findIndex(
          ({ id }) => id === this.$route.params.id
        )
        return this.$store.state.matches[match]
      }
    },
    methods: {
      goBack () {
        router.push('/matches')
      },
      playMatch () {
        var params = {status: 'in game'}
        this.$store.dispatch('updateMatch', [params, this.match])
      },
      finishMatch () {
        var params = {
          home_team_score: this.match.home_team_score,
          invited_team_score: this.match.invited_team_score,
          status: 'played'
        }
        this.$store.dispatch('updateMatch', [params, this.match])
      }
    }
  }
</script>

<style scoped>
  ul {
    list-style: none;
  }
</style>
