<template>
  <div id='tournament-matches'>
    <h3>Matches in tournament {{tournament_name}}</h3>
    <ul v-for='round in rounds'>
      <li>
        Round number: {{round.number}}
          <div v-if="round.matches.length > 0">
            <h4>Matches in round:</h4>
            <table>
              <thead>
                <th>id</th>
                <th>status</th>
                <th>home team</th>
                <th>invited team</th>
              </thead>
              <tbody>
                <tr v-for="match in round.matches" @click="showMatch(match.id)">
                  <td>{{match.id}}</td>
                  <td>{{match.status}}</td>
                  <td>{{match.home_team_name}}</td>
                  <td>{{match.invited_team_name}}</td>
                </tr>
              </tbody>
            </table>
          </div>
      </li>
    </ul>
    <p v-if="rounds.length == 0">No matches assigned</p>
  </div>
</template>

<script>
  import api from '../api'
  import { router } from '../main'
  export default {
    name: 'TournamentMatches',
    data () {
      return {
        rounds: [],
        matches: [],
        tournament_name: null
      }
    },
    mounted () {
      api.getTournament(this.$route.params.id).then(response => {
        this.rounds = response.data.rounds
        this.tournament_name = response.data.title
      })
    },
    methods: {
      showMatch (id) {
        router.push({name: 'showMatch', params: { id: id }})
      }
    }
  }
</script>

<style scoped>
  tbody tr:hover {
      background-color: #41b883;
    }
</style>
