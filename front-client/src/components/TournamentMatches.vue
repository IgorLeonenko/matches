<template>
  <div id='tournament-matches'>
    <ul v-for='round in rounds'>
      <li>
        <b>Round {{round.number}}</b>
          <div v-if="round.matches.length > 0">
            <h4>Matches in round:</h4>
            <table>
              <thead>
                <th>id</th>
                <th>status</th>
                <th>home team</th>
                <th>invited team</th>
                <th></th>
              </thead>
              <tbody>
                <tr v-for="match in round.matches">
                  <td>{{match.id}}</td>
                  <td>{{match.status}}</td>
                  <td>{{match.home_team.name}}</td>
                  <td>{{match.invited_team.name}}</td>
                  <td>
                    <button type='type' @click='playMatch(match)' v-show="match.status === 'prepare'">
                      Play match
                    </button>
                    <button type='type' @click='showMatch(match.id)' v-show="match.status === 'in game'">
                      Go to match
                    </button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
          <p v-if="round.matches.length == 0"><i>No matches assigned</i></p>
      </li>
    </ul>

  </div>
</template>

<script>
  import { router } from '../main'
  export default {
    name: 'TournamentMatches',
    props: {
      rounds: {}
    },
    methods: {
      playMatch (match) {
        match.status = 'in game'
        this.$store.dispatch('updateMatch', match)
        router.push({name: 'showMatch', params: { id: match.id }})
      },
      showMatch (id) {
        router.push({name: 'showMatch', params: { id: id }})
      }
    }
  }
</script>
